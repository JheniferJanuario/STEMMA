using STEMMA.Application.Cadastro.DTOs.Requests;
using STEMMA.Application.Cadastro.DTOs.Responses;
using STEMMA.Domain.Cadastro.Entities;

namespace STEMMA.Application.Cadastro.Tutores.Mappers;

public static class TutorMapper
{
    public static Tutor ToEntity(CreateTutorRequest request)
    {
        return new Tutor(
            request.Nome,
            request.CPF,
            request.Email
        );
    }

    public static TutorResponse ToResponse(Tutor tutor)
    {
        return new TutorResponse
        {
            Id = tutor.Id,
            Nome = tutor.Nome,
            CPF = tutor.CPF,
            Email = tutor.Email
        };
    }

    public static List<TutorResponse> ToResponseList(
        List<Tutor> tutores)
    {
        return tutores
            .Select(ToResponse)
            .ToList();
    }

    public static void UpdateEntity(
        Tutor tutor,
        UpdateTutorRequest request)
    {
        tutor.AlterarNome(request.Nome);
    }
}