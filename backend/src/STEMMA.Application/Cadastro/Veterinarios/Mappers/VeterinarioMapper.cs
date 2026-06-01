using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.Veterinarios.DTOs.Requests;
using STEMMA.Application.Cadastro.Veterinarios.DTOs.Response;
using STEMMA.Domain.Cadastro.Entities;

namespace STEMMA.Application.Cadastro.Veterinarios.Mappers;

public static class VeterinarioMapper
{
    public static Veterinario ToEntity(
        CreateVeterinarioRequest request)
    {
        return new Veterinario(
            request.Nome,
            request.CRMV,
            request.Email,
            request.Senha,
            request.Especialidade
        );
    }

    public static VeterinarioResponse ToResponse(
        Veterinario veterinario)
    {
        return new VeterinarioResponse
        {
            Id = veterinario.Id,
            Nome = veterinario.Nome,
            CRMV = veterinario.CRMV,
            Email = veterinario.Email,
            Especialidade = veterinario.Especialidade,
            DataCriacao = veterinario.DataCriacao
        };
    }

    public static List<VeterinarioResponse> ToResponseList(
        List<Veterinario> veterinarios)
    {
        return veterinarios
            .Select(ToResponse)
            .ToList();
    }
}